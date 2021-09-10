from os import startfile
import pandas as pd
import time
import datetime

from pandas.core.indexes.base import ensure_index
# Read file
df = pd.read_csv("d:/Code/Github/InterviewQuestions_Solutions/Python/Question2/sample_message_dataset.csv")
# Sort by timestamp
df = df.sort_values(by="timestamp", ignore_index= True)

def fraction_of_msg_in_5(sender, receiver, df):
    msg_count = 0
    start = 0
    end = 0
    for i in df.index:
        if df.sender_id[i] == sender and df.receiver_id[i] == receiver:
            msg_count += 1
        elif df.sender_id[i] == receiver and df.receiver_id[i] == sender:
            msg_count += 1
    for i in range(df.index.stop -1, 0, -1):
        if df.sender_id[i] == sender and df.receiver_id[i] == receiver:
            end = df.timestamp[i]
            break
        elif df.sender_id[i] == receiver and df.receiver_id[i] == sender:
            end = df.timestamp[i]
            break
    for i in df.index:
        if df.sender_id[i] == sender and df.receiver_id[i] == receiver:
            start = df.timestamp[i]
            break
        elif df.sender_id[i] == receiver and df.receiver_id[i] == sender:
            start = df.timestamp[i]
            break
    times_of_5_min = float((end - start) / (60 * 5))
    fraction = msg_count / times_of_5_min
    return fraction

print(fraction_of_msg_in_5(1,4,df))
