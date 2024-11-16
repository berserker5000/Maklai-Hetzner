import logging
import random
import time
import threading
import os

logging.basicConfig(level=logging.INFO, format="%(message)s")

num_threads = os.getenv("NUM_THREADS",10)

if type(num_threads) != "int":
    num_threads = int(num_threads)

def generate_log():
    integer_value = random.randint(1, 100)
    string_value = "log_message_" + str(random.randint(1, 1000))
    text_value = "This is a sample log text for testing."
    logging.info(f"integer_value={integer_value} string_value={string_value} text_value={text_value}")

def generate_logs(num_threads=10):
    threads = []
    for _ in range(num_threads):
        thread = threading.Thread(target=generate_log)
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

if __name__ == "__main__":
    while True:
        generate_logs(num_threads=num_threads)
        time.sleep(0.01)
