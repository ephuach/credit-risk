version = "1.0"

train {
    step preproc_agg {
        image = "basisai/workload-standard:v0.1.2"
        install = [
            "pip3 install --upgrade pip",
            "pip3 install -r requirements-train.txt",
        ]
        script = [{sh = ["python3 task_preproc_agg.py"]}]
        resources {
            cpu = "0.5"
            memory = "1G"
        }
    }

    step features_trainer {
        image = "basisai/workload-standard:v0.1.2"
        install = [
            "pip3 install --upgrade pip",
            "pip3 install -r requirements-train.txt",
        ]
        script = [{sh = ["python3 task_features_trainer.py"]}]
        resources {
            cpu = "2"
            memory = "12G"
        }
         depends_on = ["preproc_agg"]
    }

    step train {
        image = "basisai/workload-standard:v0.1.2"
        install = [
            "pip3 install --upgrade pip",
            "pip3 install -r requirements-train.txt",
        ]
        script = [{sh = ["python3 task_train.py"]}]
        resources {
            cpu = "2"
            memory = "14G"
        }
        depends_on = ["features_trainer"]
    }

    parameters {
        EXECUTION_DATE = "2019-07-01"
        MODEL_VER = "lightgbm"
        NUM_LEAVES = "34"
        MAX_DEPTH = "8"
    }
}

serve {
    image = "python:3.7"
    install = [
        "pip3 install --upgrade pip",
        "pip3 install -r requirements-serve.txt",
    ]
    script = [
        {sh = [
            "gunicorn --bind=:${BEDROCK_SERVER_PORT:-8080} --worker-class=gthread --workers=${WORKERS} --timeout=300 --preload serve_http:app"
        ]}
    ]

    parameters {
        WORKERS = "1"
    }
}

batch_score {
    step compute_shap {
        image = "basisai/workload-standard:v0.1.2"
        install = [
            "pip3 install --upgrade pip",
            "pip3 install -r requirements-train.txt",
            "pip3 install shap==0.35.0",
        ]
        script = [{sh = ["python3 task_shap.py"]}]
        resources {
            cpu = "2"
            memory = "14G"
        }
    }

    parameters {
        EXECUTION_DATE = ""
    }
}
