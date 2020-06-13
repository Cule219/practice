# join
new_str = "\n".join(["fore", "aft", "starboard", "port"])
print(new_str)

# append
letters = ['a', 'b', 'c', 'd']
letters.append('z')
print(letters)

# prepend
a = ["v1", "v2", "v3", "v4"]
print a
a.insert(0, "new val")
print a
a = ["new value2"] + a
print a

# min, max
a = [1, 5, 8]
b = [2, 6, 9, 10]
c = [100, 200]

print(max([len(a), len(b), len(c)]))
print(min([len(a), len(b), len(c)]))
