import math 
import random
import time
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from collections import Counter

def exponential_distribution(n,l):
    # Generates the sequence of events according to the exponential distribution

    event_timestamp = np.zeros(n)
    time_intervals = np.zeros(n)
    time_ = 0
    
    for i in range(n):
        random.seed(time.time())
        u = random.random()
        deltat = -math.log(1-u)/l
        time_ += deltat
        time_intervals[i] = deltat
        event_timestamp[i] = int(math.floor(time_))
        i -= 1
    return event_timestamp

def plot_histogram(data,n,l):
    # print(data)
    # Count how many times each value appears
    value_counts = Counter(data.values())
    #print(value_counts)

    # Calculate total count
    total_count = sum(value_counts.values())
    #print(total_count)

    # Calculate the percentage for each number of events
    percentages = {count: (freq / total_count) for count, freq in value_counts.items()}
    #print(percentages)

    # Plotting sample data histogram
    plt.bar(percentages.keys(), percentages.values(), align='center', alpha=0.5, label='Sample Data')
    
    # Calculating and plotting Theoretical Poisson Distribution
    theoretical_probs = [poisson_pmf(k,l) for k in range(max(data.values())+1)]
    # print(theoretical_probs)
    plt.plot(range(max(data.values()) + 1), theoretical_probs, marker='o', linestyle='-', color='r', label='Theoretical Distribution')

    plt.xlabel('Number of events')
    plt.ylabel('Percentage / Probability Density')
    plt.title('Comparison of Sample Data and Theoretical Poisson Distribution for ' + 'N = ' + str(n) + ' and λ = ' + str(int(l)))
    plt.grid(True)
    plt.legend()
    plt.show()
    return 0

def poisson_pmf(k, lambda_):
    # Probability Mass Function (PMF) of the Poisson distribution
    return np.exp(-lambda_) * (lambda_**k) / np.math.factorial(k)

def main():
    n = int(input("Number of loops\n"))
    l = float(input("Lambda\n"))
    events = exponential_distribution(n,l)
    #print (events)
    
    # Count the frequency for each number of events occuring in a unitary time interval
    event_counting = Counter(events)

    # If any value is not present in the array, add it with a frequency of 0
    for i in range(int(max(events))+1):
        if i not in event_counting:
            event_counting[i] = 0

    # Sort the dictionary by keys
    sorted_event_counting = dict(sorted(event_counting.items()))

    # Plot both histograms for the Sample Data and Theoretical Poisson Distributions
    plot_histogram(sorted_event_counting,n,l)
    return 0

if __name__== "__main__":
    main()
   
    