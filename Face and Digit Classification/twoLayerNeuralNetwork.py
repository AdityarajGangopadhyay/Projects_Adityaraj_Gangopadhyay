import numpy as np

import util
import numpy
import pickle

class TwoLayerNeuralNetwork:
    def __init__(self, input_size, hidden_size, output_size):
        self.inputSize = input_size
        self.hiddenSize = hidden_size
        self.outputSize = output_size

        # Initialize weights and biases
        self.weightsInputHidden = numpy.random.randn(self.inputSize, self.hiddenSize)
        self.biasesHidden = numpy.zeros((1, self.hiddenSize))
        self.weightsHiddenOutput = numpy.random.randn(self.hiddenSize, self.outputSize)
        self.biasesOutput = numpy.zeros((1, self.outputSize))

    def exportWeights(self, data):
        if data == "faces":
            with open("neuralFacesWeights", 'wb') as file:
                dataSave = {
                    'weightsInputHidden': self.weightsInputHidden,
                    'weightsHiddenOutput': self.weightsHiddenOutput,
                    'biasesHidden': self.biasesHidden,
                    'biasesOutput': self.biasesOutput
                }
                pickle.dump(dataSave, file)
        else:
            with open("neuralDigitsWeights", 'wb') as file:
                dataSave = {
                    'weightsInputHidden': self.weightsInputHidden,
                    'weightsHiddenOutput': self.weightsHiddenOutput,
                    'biasesHidden': self.biasesHidden,
                    'biasesOutput': self.biasesOutput
                }
                pickle.dump(dataSave, file)
        print("Weights and biases exported successfully")

    def importWeights(self, data):
        if data == "faces":
            with open("neuralFacesWeights", 'rb') as file:
                dataLoaded = pickle.load(file)
                self.weightsInputHidden = dataLoaded['weightsInputHidden']
                self.weightsHiddenOutput = dataLoaded['weightsHiddenOutput']
                self.biasesHidden = dataLoaded['biasesHidden']
                self.biasesOutput = dataLoaded['biasesOutput']
        else:
            with open("neuralDigitsWeights", 'rb') as file:
                dataLoaded = pickle.load(file)
                self.weightsInputHidden = dataLoaded['weightsInputHidden']
                self.weightsHiddenOutput = dataLoaded['weightsHiddenOutput']
                self.biasesHidden = dataLoaded['biasesHidden']
                self.biasesOutput = dataLoaded['biasesOutput']
        print("Weights and biases imported successfully")

    def sigmoid(self, z):
        return 1 / (1 + numpy.exp(-z))

    def sigmoidDerivative(self, z):
        return z * (1 - z)

    def train(self, trainingData, trainingLabels, learningRate=0.20, epochs=1000):
        for epoch in range(epochs):

            hiddenLayerInput = numpy.dot(trainingData, self.weightsInputHidden) + self.biasesHidden
            hiddenLayerOutput = self.sigmoid(hiddenLayerInput)

            finalLayerInput = numpy.dot(hiddenLayerOutput, self.weightsHiddenOutput) + self.biasesOutput
            finalLayerOutput = self.sigmoid(finalLayerInput)

            error = trainingLabels - finalLayerOutput

            dFinalOutput = error * self.sigmoidDerivative(finalLayerOutput)
            errorHiddenLayer = dFinalOutput.dot(self.weightsHiddenOutput.T)
            dHiddenLayer = errorHiddenLayer * self.sigmoidDerivative(hiddenLayerOutput)

            self.weightsHiddenOutput += hiddenLayerOutput.T.dot(dFinalOutput) * learningRate
            self.biasesOutput += numpy.sum(dFinalOutput, axis=0, keepdims=True) * learningRate
            self.weightsInputHidden += trainingData.T.dot(dHiddenLayer) * learningRate
            self.biasesHidden += numpy.sum(dHiddenLayer, axis=0, keepdims=True) * learningRate

            loss = np.mean(np.square(error))
            # print(loss)

    def classify(self, data):
        hiddenLayerInput = numpy.dot(data, self.weightsInputHidden) + self.biasesHidden
        hiddenLayerOutput = self.sigmoid(hiddenLayerInput)

        finalLayerInput = numpy.dot(hiddenLayerOutput, self.weightsHiddenOutput) + self.biasesOutput
        finalLayerOutput = self.sigmoid(finalLayerInput)

        guesses = numpy.array(finalLayerOutput)
        guesses = numpy.argmax(guesses, axis=1)

        return guesses