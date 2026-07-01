import streamlit as st
import speedtest
import plotly.graph_objects as go
import math

st.set_page_config(page_title="Speed Test", page_icon="🚀", layout="centered")
st.title("Internet Speed Test")
st.write("Run a quick download/upload test and view the results in real time.")

if st.button("Run speed test", width="stretch"):
    progress_bar = st.progress(0, text="Preparing speed test...")
    status_text = st.empty()

    with st.spinner("Testing your connection..."):
        status_text.info("Finding the best server...")
        s = speedtest.Speedtest()
        s.get_best_server()
        progress_bar.progress(33, text="Measuring download speed...")

        status_text.info("Measuring download speed...")
        download_mbps = round(s.download() / 1e6, 2)

        progress_bar.progress(66, text="Measuring upload speed...")
        status_text.info("Measuring upload speed...")
        upload_mbps = round(s.upload() / 1e6, 2)

        ping_ms = round(s.results.ping, 1)
        progress_bar.progress(100, text="Finalizing results...")

    status_text.success("Speed test complete!")

    col1, col2, col3 = st.columns(3)
    col1.metric("Download", f"{download_mbps} Mbps")
    col2.metric("Upload", f"{upload_mbps} Mbps")
    col3.metric("Ping", f"{ping_ms} ms")

    max_gauge = math.ceil(download_mbps / 100) * 100
    if max_gauge == download_mbps:
        max_gauge += 100
    fig = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=download_mbps,
            title={"text": "Download Speed (Mbps)"},
            gauge={"axis": {"range": [0, max_gauge]}}
        )
    )
    st.plotly_chart(fig, width="stretch")
else:
    st.info("Press the button above to start the test.")