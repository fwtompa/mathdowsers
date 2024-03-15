import os

SRC_PATH = os.path.dirname(os.path.abspath(__file__))
BASE_PATH = os.path.dirname(SRC_PATH)
DATA_PATH = os.path.join(BASE_PATH, "data")
DATA_PROCESSED = os.path.join(DATA_PATH, "processed")
DATA_ORIGINAL = os.path.join(DATA_PATH, "original")

### raw data
ARQM_DATA_PATH = DATA_ORIGINAL
STORAGE_ARQM_DATA_PATH = DATA_ORIGINAL

ARQM_FORMULAS_PATH = DATA_ORIGINAL
ARQM_TASK1_PATH = DATA_ORIGINAL
ARQM_TASK2_PATH = DATA_ORIGINAL


### generated data
ARQM_PREPRO_PATH = DATA_PROCESSED


### Formula folders
FORMULA_FOLDER_CONFIG = {
    "latex": ("latex_representation_v3", range(1, 102)),
    "opt": ("opt_representation_v3", range(1, 102)),
    "slt": ("slt_representation_v3", range(1, 102)),
}

TASK_FORMULA_FOLDER_CONFIG = {
    2020: {
        "latex": os.path.join(ARQM_TASK1_PATH, "Formula_topics_latex_V2.0.tsv"),
        "slt_original": os.path.join(ARQM_TASK1_PATH, "Formula_topics_slt_V2.0.tsv"),
        "slt": os.path.join(ARQM_TASK1_PATH, "Topics_2020_converted_Formula_slt_V2.0.tsv"),
    },
    2021: {
        "latex": os.path.join(ARQM_TASK1_PATH, "Topics_2021_Formulas_Latex_V1.1.tsv"),
        "slt": os.path.join(ARQM_TASK1_PATH, "Topics_2021_Formulas_SLT_V1.1.tsv"),
    },
    2022: {
        "latex": os.path.join(ARQM_TASK1_PATH, "Topics_Formulas_Latex.V0.1.tsv"),
        "slt": os.path.join(ARQM_TASK1_PATH, "Topics_Formulas_SLT.V0.1.tsv"),
    }
}
