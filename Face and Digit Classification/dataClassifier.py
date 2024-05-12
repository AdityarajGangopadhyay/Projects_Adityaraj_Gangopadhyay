# dataClassifier.py
# -----------------
# Licensing Information: Please do not distribute or publish solutions to this
# project. You are free to use and extend these projects for educational
# purposes. The Pacman AI projects were developed at UC Berkeley, primarily by
# John DeNero (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# For more info, see http://inst.eecs.berkeley.edu/~cs188/sp09/pacman.html
import random
import time
import numpy
from tensorflow.keras.utils import to_categorical

# This file contains feature extraction methods and harness 
# code for data classification

import perceptron
import samples
import sys

import twoLayerNeuralNetwork
import util

TEST_SET_SIZE = 100
DIGIT_DATUM_WIDTH=28
DIGIT_DATUM_HEIGHT=28
FACE_DATUM_WIDTH=60
FACE_DATUM_HEIGHT=70


def basicFeatureExtractorDigit(datum):
  """
  Returns a set of pixel features indicating whether
  each pixel in the provided datum is white (0) or gray/black (1)
  """
  a = datum.getPixels()

  features = util.Counter()
  for x in range(DIGIT_DATUM_WIDTH):
    for y in range(DIGIT_DATUM_HEIGHT):
      if datum.getPixel(x, y) > 0:
        features[(x,y)] = 1
      else:
        features[(x,y)] = 0
  return features

def basicFeatureExtractorFace(datum):
  """
  Returns a set of pixel features indicating whether
  each pixel in the provided datum is an edge (1) or no edge (0)
  """
  a = datum.getPixels()

  features = util.Counter()
  for x in range(FACE_DATUM_WIDTH):
    for y in range(FACE_DATUM_HEIGHT):
      #print(datum)
      if datum.getPixel(x, y) > 0:
        features[(x,y)] = 1
      else:
        features[(x,y)] = 0
  return features

def default(str):
  return str + ' [Default: %default]'

def readCommand( argv ):
  "Processes the command used to run from the command line."
  from optparse import OptionParser  
  parser = OptionParser(USAGE_STRING)

  parser.add_option('-c', '--classifier', help=default('The type of classifier'), choices=['mostFrequent', 'nb', 'naiveBayes', 'perceptron', 'mira', 'minicontest', 'neural'], default='mostFrequent')
  parser.add_option('-d', '--data', help=default('Dataset to use'), choices=['digits', 'faces'], default='digits')
  parser.add_option('-t', '--training', help=default('The size of the training set'), default=0, type="int")
  parser.add_option('-i', '--iterations', help=default("Maximum iterations to run training (epochs) for Perceptron"), default=3, type="int")
  parser.add_option('-s', '--test', help=default("Amount of test data to use"), default=TEST_SET_SIZE, type="int")
  parser.add_option('-e', '--export', help=default("Whether to export the weights"), default=False, action="store_true")

  print(argv)

  options, otherjunk = parser.parse_args(argv)
  if len(otherjunk) != 0: raise Exception('Command line input not understood: ' + str(otherjunk))
  args = {}

  if options.training != 0 and options.training < 10:
    print("If training, then training set size needs to be at least 10.")
    sys.exit()
  
  # Set up variables according to the command line input.
  print("Doing classification")
  print("--------------------")
  print("data:\t\t" + options.data)
  print("classifier:\t\t" + options.classifier)
  print("training set size:\t" + str(options.training))

  if(options.data=="digits"):
    featureFunction = basicFeatureExtractorDigit
  elif(options.data=="faces"):
    featureFunction = basicFeatureExtractorFace
  else:
    print("Unknown dataset", options.data)
    print(USAGE_STRING)
    sys.exit(2)
    
  if(options.data=="digits"):
    legalLabels = range(10)
  else:
    legalLabels = range(2)

  if(options.classifier == "perceptron"):
    classifier = perceptron.PerceptronClassifier(legalLabels,options.iterations)
  elif (options.classifier == "neural"):
    if options.data == "digits":
      classifier = twoLayerNeuralNetwork.TwoLayerNeuralNetwork(DIGIT_DATUM_WIDTH*DIGIT_DATUM_HEIGHT, 10, 10)
    else:
      classifier = twoLayerNeuralNetwork.TwoLayerNeuralNetwork(FACE_DATUM_WIDTH*FACE_DATUM_HEIGHT, 3, 2)
  else:
    print("Unknown classifier:", options.classifier)
    print(USAGE_STRING)
    
    sys.exit(2)

  args['classifier'] = classifier
  args['featureFunction'] = featureFunction

  return args, options

USAGE_STRING = """
  USAGE:      python dataClassifier.py <options>
  EXAMPLES:   (1) python dataClassifier.py
                  - trains the default mostFrequent classifier on the digit dataset
                  using the default 100 training examples and
                  then test the classifier on test data
              (2) python dataClassifier.py -c naiveBayes -d digits -t 1000 -f -o -1 3 -2 6 -k 2.5
                  - would run the naive Bayes classifier on 1000 training examples
                  using the enhancedFeatureExtractorDigits function to get the features
                  on the faces dataset, would use the smoothing parameter equals to 2.5, would
                  test the classifier on the test data and performs an odd ratio analysis
                  with label1=3 vs. label2=6
                 """

# Main harness code

def runClassifier(args, options):

  featureFunction = args['featureFunction']
  classifier = args['classifier']

  # Load data  
  numTraining = options.training
  numTest = options.test

  if(options.data=="faces"):
    rawTrainingData = samples.loadDataFile("facedata/facedatatrain", numTraining,FACE_DATUM_WIDTH,FACE_DATUM_HEIGHT)
    trainingLabels = samples.loadLabelsFile("facedata/facedatatrainlabels", numTraining)
    rawValidationData = samples.loadDataFile("facedata/facedatatrain", numTest,FACE_DATUM_WIDTH,FACE_DATUM_HEIGHT)
    validationLabels = samples.loadLabelsFile("facedata/facedatatrainlabels", numTest)
    rawTestData = samples.loadDataFile("facedata/facedatatest", numTest,FACE_DATUM_WIDTH,FACE_DATUM_HEIGHT)
    testLabels = samples.loadLabelsFile("facedata/facedatatestlabels", numTest)
  else:
    rawTrainingData = samples.loadDataFile("digitdata/trainingimages", numTraining,DIGIT_DATUM_WIDTH,DIGIT_DATUM_HEIGHT)
    trainingLabels = samples.loadLabelsFile("digitdata/traininglabels", numTraining)
    rawValidationData = samples.loadDataFile("digitdata/validationimages", numTest,DIGIT_DATUM_WIDTH,DIGIT_DATUM_HEIGHT)
    validationLabels = samples.loadLabelsFile("digitdata/validationlabels", numTest)
    rawTestData = samples.loadDataFile("digitdata/testimages", numTest,DIGIT_DATUM_WIDTH,DIGIT_DATUM_HEIGHT)
    testLabels = samples.loadLabelsFile("digitdata/testlabels", numTest)

  trainingData = map(featureFunction, rawTrainingData)
  trainingData = list(trainingData)
  validationData = map(featureFunction, rawValidationData)
  validationData = list(validationData)
  testData = map(featureFunction, rawTestData)
  testData = list(testData)

  if options.classifier == "perceptron":
    if options.training != 0:
      for percentage in range(1,11):
        trainingTimes = []
        testingAccuracies = []
        numberPercentageTrainingData = int(numTraining * (percentage / 10))

        print()
        print("---------------------------------------------------------")
        print("Extracting and Training on", percentage * 10, "% of data reserved for training. (", numberPercentageTrainingData, " datapoint(s).)")
        print()

        for overallIteration in range(1, 6):
          indexes = random.sample(range(numTraining), numberPercentageTrainingData)
          percentageTrainingDataLabel = []
          percentageTrainingData = []

          for i in indexes:
            percentageTrainingDataLabel.append(trainingLabels[i])
            percentageTrainingData.append(trainingData[i])

          print("Iteration ", overallIteration, ": Training...")
          timeStart = time.time()
          classifier.train(percentageTrainingData, percentageTrainingDataLabel, validationData, validationLabels)
          timeEnd = time.time()
          trainingTimes.append(timeEnd - timeStart)
          print("Iteration ", overallIteration, ": Training Took ", timeEnd - timeStart)

          print("Iteration ", overallIteration, ": Testing...")
          guesses = classifier.classify(testData)
          correct = [guesses[i] == testLabels[i] for i in range(len(testLabels))].count(True)
          testingAccuracies.append((correct * 100) / len(testLabels))
          print("Iteration ", overallIteration, ":", str(correct), ("correct out of " + str(len(testLabels)) + " (%.1f%%).") % (100.0 * correct / len(testLabels)))
          print()

        print("-------------------------")
        print("Average training time for ", numberPercentageTrainingData, "datapoint(s) (", percentage * 10, "%): ", numpy.mean(trainingTimes))
        print("Average accuracy from ", numberPercentageTrainingData, "datapoint(s) (", percentage * 10, "%): ", numpy.mean(testingAccuracies))
        print("Standard Deviation: ", numpy.std(testingAccuracies))

      if options.export == True:
        print()
        classifier.exportWeights(options.data)
    else:
      print()
      classifier.importWeights(options.data)
      print("Testing...")
      guesses = classifier.classify(testData)
      correct = [guesses[i] == testLabels[i] for i in range(len(testLabels))].count(True)
      print("Guesses:")
      print(guesses)
      print("Actual:")
      print(testLabels)
      print(str(correct), ("correct out of " + str(len(testLabels)) + " (%.1f%%).") % (100.0 * correct / len(testLabels)))
      print()
  else:
    temp = []
    if options.data == 'faces':
      for data in testData:
        testImage = numpy.zeros(FACE_DATUM_WIDTH * FACE_DATUM_HEIGHT)

        for (x, y), value in data.items():
          i = y * FACE_DATUM_WIDTH + x
          testImage[i] = value

        temp.append(testImage)
    else:
      for data in testData:
        testImage = numpy.zeros(DIGIT_DATUM_WIDTH * DIGIT_DATUM_HEIGHT)

        for (x, y), value in data.items():
          i = y * DIGIT_DATUM_WIDTH + x
          testImage[i] = value

        temp.append(testImage)
    testData = numpy.array(temp)

    if options.data == "faces":
      testLabelsC = to_categorical(testLabels, num_classes=2)
    else:
      testLabelsC = to_categorical(testLabels, num_classes=10)

    correctLabels = numpy.argmax(testLabelsC, axis=1)

    if options.training != 0:
      for percentage in range(1,11):
        trainingTimes = []
        testingAccuracies = []
        numberPercentageTrainingData = int(numTraining * (percentage / 10))

        print()
        print("---------------------------------------------------------")
        print("Extracting and Training on", percentage * 10, "% of data reserved for training. (", numberPercentageTrainingData, " datapoint(s).)")
        print()

        for overallIteration in range(1, 6):
          indexes = random.sample(range(numTraining), numberPercentageTrainingData)
          percentageTrainingDataLabel = []
          percentageTrainingData = []

          for i in indexes:
            percentageTrainingDataLabel.append(trainingLabels[i])
            percentageTrainingData.append(trainingData[i])

          temp = []
          if options.data == 'faces':
            for data in percentageTrainingData:
              image = numpy.zeros(FACE_DATUM_WIDTH * FACE_DATUM_HEIGHT)

              for (x, y), value in data.items():
                i = y * FACE_DATUM_WIDTH + x
                image[i] = value

              temp.append(image)
          else:
            for data in percentageTrainingData:
              image = numpy.zeros(DIGIT_DATUM_WIDTH * DIGIT_DATUM_HEIGHT)

              for (x, y), value in data.items():
                i = y * DIGIT_DATUM_WIDTH + x
                image[i] = value

              temp.append(image)

          percentageTrainingData = numpy.array(temp)

          if options.data == 'faces':
            percentageTrainingDataLabel = to_categorical(percentageTrainingDataLabel, num_classes=2)
          else:
            percentageTrainingDataLabel = to_categorical(percentageTrainingDataLabel, num_classes=10)

          print("Iteration ", overallIteration, ": Training...")
          timeStart = time.time()
          if options.data == "faces":
            classifier.train(percentageTrainingData, percentageTrainingDataLabel, 0.20)
          else:
            classifier.train(percentageTrainingData, percentageTrainingDataLabel, 0.001)
          timeEnd = time.time()
          trainingTimes.append(timeEnd - timeStart)
          print("Iteration ", overallIteration, ": Training Took ", timeEnd - timeStart)
          print("Iteration ", overallIteration, ": Testing...")

          guesses = classifier.classify(testData)
          # guesses = numpy.array(guesses)
          # guesses = numpy.argmax(guesses, axis=1)
          correct = (guesses == correctLabels).sum()
          testingAccuracies.append((correct *100)/ len(testLabelsC))
          print("Iteration ", overallIteration, ":", str(correct), ("correct out of " + str(len(testLabels)) + " (%.1f%%).") % (100.0 * correct / len(testLabels)))
          print()

        print("-------------------------")
        print("Average training time for ", numberPercentageTrainingData, "datapoint(s) (", percentage * 10, "%): ", numpy.mean(trainingTimes))
        print("Average accuracy from ", numberPercentageTrainingData, "datapoint(s) (", percentage * 10, "%): ", numpy.mean(testingAccuracies))
        print("Standard Deviation: ", numpy.std(testingAccuracies))

      if options.export == True:
        print()
        classifier.exportWeights(options.data)
    else:
      print()
      classifier.importWeights(options.data)
      print("Testing...")

      guesses = classifier.classify(testData)
      # guesses = numpy.array(guesses)
      # guesses = numpy.argmax(guesses, axis=1)
      correct = (guesses == correctLabels).sum()
      print("Guesses:")
      print(guesses)
      print("Actual:")
      print(correctLabels)
      print(str(correct), ("correct out of " + str(len(testLabels)) + " (%.1f%%).") % (100.0 * correct / len(testLabels)))
      print()

if __name__ == '__main__':
  # Read input
  args, options = readCommand( sys.argv[1:] ) 
  # Run classifier
  runClassifier(args, options)