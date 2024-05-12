# perceptron.py
# -------------
# Licensing Information: Please do not distribute or publish solutions to this
# project. You are free to use and extend these projects for educational
# purposes. The Pacman AI projects were developed at UC Berkeley, primarily by
# John DeNero (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# For more info, see http://inst.eecs.berkeley.edu/~cs188/sp09/pacman.html
import sys
import pickle

# Perceptron implementation
import util
PRINT = True

class PerceptronClassifier:
  """
  Perceptron classifier.
  
  Note that the variable 'datum' in this code refers to a counter of features
  (not to a raw samples.Datum).
  """
  def __init__( self, legalLabels, epochs):
    self.legalLabels = legalLabels
    self.type = "perceptron"
    self.epochs = epochs
    self.weights = {}
    for label in legalLabels:
      self.weights[label] = util.Counter() # this is the data-structure you should use

  # def setWeights(self, weights):
  #   assert len(weights) == len(self.legalLabels);
  #   self.weights == weights;

  def exportWeights(self, data):
      if data == "digits":
          with open("perceptronDigitsWeights", 'wb') as file:
              pickle.dump(self.weights, file)
      else:
          with open("perceptronFacesWeights", 'wb') as file:
              pickle.dump(self.weights, file)
      print("Weights exported successfully.")

  def importWeights(self, data):
      if data == "digits":
          with open("perceptronDigitsWeights", 'rb') as file:
              self.weights = pickle.load(file)
      else:
          with open("perceptronFacesWeights", 'rb') as file:
              self.weights = pickle.load(file)
      print("Weights imported successfully.")
      
 # A Python function for training a perceptron by updating the weight vector based on classification errors.
  def train( self, trainingData, trainingLabels, validationData, validationLabels ):
    """
    The training loop for the perceptron passes through the training data several
    times and updates the weight vector for each label based on classification errors.
    See the project description for details. 
    
    Use the provided self.weights[label] data structure so that 
    the classify method works correctly. Also, recall that a
    datum is a counter from features to values for those features
    (and thus represents a vector a values).
    """
    
    self.features = trainingData[0].keys() # could be useful later
    # DO NOT ZERO OUT YOUR WEIGHTS BEFORE STARTING TRAINING, OR
    # THE AUTOGRADER WILL LIKELY DEDUCT POINTS.

    bestAccuracy = 0
    for epoch in range(self.epochs):
      for i in range(len(trainingData)):
          "*** YOUR CODE HERE ***"
          label, best = None, None

          for legalLabel in self.legalLabels:
              score = 0

              for feature, num in trainingData[i].items():
                  score += num * self.weights[legalLabel][feature]

              if best is None or score > best:
                  best = score
                  label = legalLabel

          trainingLabel = trainingLabels[i]

          if label != trainingLabel:
              self.weights[trainingLabel] = self.weights[trainingLabel] + trainingData[i]
              self.weights[label] = self.weights[label] - trainingData[i]

      valid = self.classify(validationData)

      currAccuracy = sum(valid[j] == validationLabels[j] for j in range(len(validationLabels)))

      if currAccuracy > bestAccuracy:
          bestAccuracy = currAccuracy
          newWeight = self.weights.copy()

    self.weights = newWeight

  def classify(self, data ):
    """
    Classifies each datum as the label that most closely matches the prototype vector
    for that label.  See the project description for details.
    
    Recall that a datum is a util.counter... 
    """
    guesses = []
    for datum in data:
      vectors = util.Counter()
      for l in self.legalLabels:
        vectors[l] = self.weights[l] * datum
      guesses.append(vectors.argMax())
    return guesses
