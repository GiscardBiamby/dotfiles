import matplotlib.pyplot as plt
import numpy as np


def plot_grid(images: list[np.ndarray], max_rows=4, max_cols=2):
    fig, axes = plt.subplots(nrows=max_rows, ncols=max_cols, figsize=(40, 40))
    for idx, image in enumerate(images[: max_rows * max_cols]):
        row = idx // max_cols
        col = idx % max_cols
        axes[row, col].axis("off")
        axes[row, col].imshow(image, cmap="gray", aspect="auto")
    plt.subplots_adjust(wspace=0.05, hspace=0.05)
    plt.show()
