import json

dataset = json.load(open('input_noPU.json'))
field = 'noPU_files'

file = 'inputs.yaml'
f = None
try:
    with open(file, 'a+') as f:
        f.write("{0}:\n".format(field))
        for data in dataset:
                name = data['file'][0]['name']
                f.write("  - root://cmsxrootd.fnal.gov//{0}\n".format(name))  # \n
finally:
    if f is not None:
        f.close()