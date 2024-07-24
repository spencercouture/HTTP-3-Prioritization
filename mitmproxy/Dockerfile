FROM mitmproxy/mitmproxy

run pip install pytz

ENTRYPOINT ["mitmdump"]
CMD ["-s", "/run/mitmproxy2mahimahi.py", "--set", "output=/run/output"]
