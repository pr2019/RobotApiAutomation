import json


def read_request_data():
    file = open('C:\\Users\\prade\\PycharmProjects\\RobotApiAutomation\\RequestJosn.json', 'r')
    jsonFile = file.read()
    json_content = json.loads(jsonFile)

    return json_content
