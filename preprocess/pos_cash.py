"""
Script to perform preprocessing of pos_cash data.
"""
import time
from datetime import timedelta

import numpy as np
import pandas as pd

from .utils import onehot_enc

AUX_DIR = "data/auxiliary/"

CATEGORICAL_COLS = ['NAME_CONTRACT_STATUS']

CATEGORIES = [
    ['Active', 'Amortized debt', 'Approved', 'Canceled', 'Completed', 'Demand', 'Returned to the store', 'Signed', 'XNA'],
]


def pos_cash():
    pos = pd.read_parquet(AUX_DIR + 'POS_CASH_balance.gz.parquet')
    
    # One-hot encoding of categorical features
    pos, cat_cols = onehot_enc(pos, CATEGORICAL_COLS, CATEGORIES)
    
    # Features
    aggregations = {
        'MONTHS_BALANCE': ['max', 'mean', 'size'],
        'SK_DPD': ['max', 'mean'],
        'SK_DPD_DEF': ['max', 'mean']
    }
    for cat in cat_cols:
        aggregations[cat] = ['mean']
    
    pos_agg = pos.groupby('SK_ID_CURR').agg(aggregations)
    pos_agg.columns = pd.Index(['POS_' + e[0] + "_" + e[1].upper() for e in pos_agg.columns.tolist()])
    # Count pos cash accounts
    pos_agg['POS_COUNT'] = pos.groupby('SK_ID_CURR').size()
    return pos_agg
    