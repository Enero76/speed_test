# speed_test

A simple Streamlit-based internet speed test app that measures download/upload speed and ping, then displays results with a Plotly gauge.
This app is to be run locally. If run on a server it will measure the speed test of that server.

## Features

- Run a download/upload speed test from the browser
- Show download, upload, and ping metrics
- Display a dynamic gauge for download speed
- Includes a launcher script to create and run a Python virtual environment

## Requirements

- Python 3.11
- Streamlit
- Plotly
- speedtest-cli

## Setup

```bash
./launch_streamlit.sh
```

Or manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
streamlit run streamlit_app.py
```

## Files

- `streamlit_app.py` &mdash; Streamlit app source
- `launch_streamlit.sh` &mdash; Launcher script that creates/uses a venv
- `requirements.txt` &mdash; Python dependencies
- `environment.yml` &mdash; Optional Conda environment spec
- `.gitignore` &mdash; Ignored files for git

## License

This project is licensed under the MIT License.
