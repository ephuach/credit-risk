"""
Script to preprocess and aggregate raw data.
"""
from preprocess.utils import get_execution_date


def preproc_raw(execution_date):
    """Entry point to preprocess and aggregate raw data."""

    # This is only a simulation step of preprocessing raw data
    # and saving the preprocessed data in application/ and auxiliary/.
    import time
    time.sleep(60)


def main():
    execution_date = get_execution_date()
    print(execution_date.strftime("\nExecution date is %Y-%m-%d"))
    preproc_raw(execution_date)


if __name__ == "__main__":
    main()
