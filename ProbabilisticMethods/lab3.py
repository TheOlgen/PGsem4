import random
import matplotlib.pyplot as plt
# 1. Z generatora liczb U(0, 1) (może być z jakiejś biblioteki) zrób generator liczb U(50, 150) przy użyciu metody odwracania dystrybuanty
# 2. Zrób generator liczb o rozkładzie dyskretnym, gdzie
#     P(X = 1) = 0.2
#     P(X = 2) = 0.3
#     P(X = 3) = 0.4
#     P(X = 4) = 0.1
#
def odwr_dystrybuanta(a, b, nums):
    for i in range(len(nums)):
        nums[i] = a + nums[i] * (b - a)
    return nums

def dyskretny_generator(U_vals):
    wynik = []
    for u in U_vals:
        if u < 0.2:
            wynik.append(1)
        elif u < 0.5:
            wynik.append(2)
        elif u < 0.9:
            wynik.append(3)
        else:
            wynik.append(4)
    return wynik


N = 10000
nums = [random.random() for _ in range(N)]
nums = odwr_dystrybuanta(50, 150, nums)

plt.plot(nums, ".")
plt.show()

# Generowanie
U_vals = [random.random() for _ in range(N)]
X_vals = dyskretny_generator(U_vals)

# Wizualizacja
plt.hist(X_vals, bins=[0.5,1.5,2.5,3.5,4.5], edgecolor='black', rwidth=0.8)
plt.xticks([1, 2, 3, 4])
plt.title("Histogram dyskretnego rozkładu")
plt.xlabel("Wartość X")
plt.ylabel("Liczność")
plt.show()
