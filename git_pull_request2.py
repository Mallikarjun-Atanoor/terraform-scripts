import requests

response = requests.get("https://api.github.com/repos/kubernetes/kubernetes/pulls")

full_details = response.json()

for i in range(len(full_details)):
    print(full_details[i]["user"]["login"])

