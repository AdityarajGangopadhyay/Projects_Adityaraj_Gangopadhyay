import logging

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
import sys
from scapy.layers.http import HTTPRequest, HTTPResponse
from scapy.layers.inet import TCP, IP
import math


def KL_divergence(distribution_1, distribution_2):
    kl_sum = 0.0
    for i in range(len(distribution_1)):
        if distribution_1[i] == 0 or distribution_2[i] == 0:
            continue
        kl_sum += distribution_1[i] * math.log2((distribution_1[i]) / (distribution_2[i]))
    return kl_sum


if __name__ == "__main__":
    load_layer("http")

    latencies = []
    requestTime = None

    for packet in rdpcap(sys.argv[1]):
        if packet.haslayer(IP) and packet.haslayer(TCP):
            if packet[IP].dst == sys.argv[2] and packet[TCP].dport == int(sys.argv[3]) and packet.haslayer(HTTPRequest):
                requestTime = packet.time

            elif packet[IP].src == sys.argv[2] and packet[TCP].sport == int(sys.argv[3]) and packet.haslayer(HTTPResponse):
                latencies.append(packet.time - requestTime)

    latencies.sort()
    percentiles = []

    for i in [25, 50, 75, 95, 99]:
        percentiles.append(latencies[int(len(latencies) * i / 100)])

    print("AVERAGE LATENCY: " + str(round(sum(latencies) / len(latencies), 5)))
    print("PERCENTILES: " + str(round(percentiles[0], 5)) + " " + str(round(percentiles[1], 5)) + " " + str(round(percentiles[2], 5)) + " " + str(round(percentiles[3], 5)) + " "
          + str(round(percentiles[4], 5)))

    bucketRange = max(latencies) / 10
    buckets = [0] * 10

    for latency in latencies:
        index = min(int(latency / bucketRange), 9)
        buckets[index] += 1

    measuredDistribution = []
    for count in buckets:
        measuredDistribution.append(count / len(latencies))

    Lambda = 1.0 / float((sum(latencies) / len(latencies)))

    modeledDistribution = [0] * 10
    for i in range(10):
        low = i * bucketRange
        if i < 9:
            high = (i + 1) * bucketRange
        else:
            high = float('inf')

        modeledDistribution[i] = (math.exp(-Lambda * low)) - (math.exp(-Lambda * high))

    klDivergence = KL_divergence(measuredDistribution, modeledDistribution)

    print("KL DIVERGENCE: " + str(round(klDivergence, 5)))
