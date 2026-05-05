import lifelines
import datetime
import pandas as pd
import numpy as np

# Visualization library
import altair as alt
alt.data_transformers.enable('default', max_rows=None)

# Dates management

# For the computation of Kaplan-Meier estimates and log-rank tests

df_person = pd.read_pickle('final_project/data/df_person.pkl')
df_person.info()
print(df_person.head())

df_condition = pd.read_pickle('final_project/data/df_condition.pkl')
df_condition.info()
print(df_condition.head())

df_visit = pd.read_pickle('final_project/data/df_visit.pkl')
df_visit.info()
print(df_visit.head())

df_bio = pd.read_pickle('final_project/data/df_bio.pkl')
df_bio.info()
print(df_bio.head())

df_dedup_deterministic = pd.read_pickle(
    'final_project/data/df_dedup_deterministic.pkl')
df_dedup_deterministic.info()
print(df_dedup_deterministic.head())

df_dedup_proba = pd.read_pickle('final_project/data/df_dedup_proba.pkl')
df_dedup_proba.info()
print(df_dedup_proba.head())

df_dedup = pd.read_pickle('final_project/data/df_dedup.pkl')
df_dedup.info()
print(df_dedup.head())

df_note = pd.read_pickle('final_project/data/df_note.pkl')
df_note.info()
print(df_note.head())
