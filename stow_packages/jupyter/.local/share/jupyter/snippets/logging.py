import logging

handler = logging.StreamHandler()
handler = logging.FileHandler(filename="log.txt", mode="a")
formatter = logging.Formatter("%(levelname)s: %(message)s")
handler.setFormatter(formatter)

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# Override the default handler
logger.handlers = [handler]

logging.error("this is an error")
logging.warning("this is a warning")