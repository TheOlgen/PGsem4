import numpy as np
import matplotlib.pyplot as plt

from data import get_data, inspect_data, split_data, get_theta

data = get_data()
inspect_data(data)

train_data, test_data = split_data(data)

# Simple Linear Regression
# predict MPG (y, dependent variable) using Weight (x, independent variable) using closed-form solution
# y = theta_0 + theta_1 * x - we want to find theta_0 and theta_1 parameters that minimize the prediction error

# We can calculate the error using MSE metric:
# MSE = SUM (from i=1 to n) (actual_output - predicted_output) ** 2

# get the columns
y_train = train_data['MPG'].to_numpy()
x_train = train_data['Weight'].to_numpy()

y_test = test_data['MPG'].to_numpy()
x_test = test_data['Weight'].to_numpy()


# TODO: calculate closed-form solution
#theta_best = [0, 0]
X_train = np.c_[np.ones(x_train.shape[0]), x_train]
X_test = np.c_[np.ones(x_test.shape[0]), x_test]
theta_best = np.linalg.inv(X_train.T.dot(X_train)).dot(X_train.T).dot(y_train)

print("θ (best theta)\t\t", theta_best)


# TODO: calculate error
error = np.mean((get_theta(theta_best, x_test) - y_test) ** 2)
print("MSE (linear) = ", error)


# plot the regression line
x = np.linspace(min(x_test), max(x_test), 100)
y = get_theta(theta_best, x)
plt.plot(x, y)
plt.scatter(x_test, y_test)
plt.xlabel('Weight')
plt.ylabel('MPG')
plt.show()


# TODO: standardization
# średnia i odchylenie standardowe
x_mean = np.mean(x_train)
x_std = np.std(x_train)
y_mean = np.mean(y_train)
y_std = np.std(y_train)
# Standaryzacja danych
x_train = (x_train - x_mean) / x_std
x_test = (x_test - x_mean) / x_std
y_train = (y_train - y_mean) / y_std
y_test = (y_test - y_mean) / y_std


# TODO: calculate theta using Batch Gradient Descent
# Parametry
learning_rate = 0.1
n_iterations = 1000
tolerance = 1e-6
m = len(x_train)

theta = np.random.rand(2)  # Losowa inicjalizacja parametrów theta_0 i theta_1
x_train = np.c_[np.ones(m), x_train]  # Dodanie kolumny jedynek dla theta_0

for iteration in range(n_iterations):
    predictions = x_train.dot(theta)  # Obliczenie prognozy y_hat = theta_0 + theta_1 * x
    cost = (1 / (2 * m)) * np.sum(predictions - y_train ** 2)  # MSE
    gradient = (1 / m) * x_train.T.dot(predictions - y_train)

    theta -= learning_rate * gradient    # Aktualizacja parametrów theta przeciwnie do gradientu

    # Sprawdzenie kryterium stopu
    if abs(error - cost) < tolerance:
        break
    error = cost


# TODO: calculate error
error = np.mean((get_theta(theta, x_test) - y_test) ** 2)
print("MSE (standarized) = ", error)


# plot the regression line
x = np.linspace(min(x_test), max(x_test), 100)
y = float(theta[0]) + float(theta[1]) * x
plt.plot(x, y)
plt.scatter(x_test, y_test)
plt.xlabel('Weight')
plt.ylabel('MPG')
plt.show()
