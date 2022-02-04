import json
import os
from io import BytesIO
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Union, cast
import cv2
import matplotlib as plt
import numpy as np
import pandas as pd
import PIL.Image as pil_img
import seaborn as sns
import sklearn as skl
from IPython.display import Image, display
from matplotlib_inline.backend_inline import set_matplotlib_formats
from matplotlib.patches import Rectangle
from tqdm.notebook import tqdm

# Multi-core pandas compat:
# import pandas as pd
# import modin.pandas as pd

USE_RAY = False
if USE_RAY:
    import ray

    ray.init(ignore_reinit_error=True)