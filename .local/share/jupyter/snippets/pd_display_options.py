pd.set_option("display.max_colwidth", None)
pd.set_option("display.max_columns", 15)
pd.set_option("display.max_rows", 50)
# Suitable default display for floats
pd.options.display.float_format = "{:,.2f}".format
plt.rcParams["figure.figsize"] = (12, 10)

# This one is optional -- change graphs to SVG only use if you don't have a
# lot of points/lines in your graphs. Can also just use ['retina'] if you
# don't want SVG.
%config InlineBackend.figure_formats = ["retina"]
set_matplotlib_formats("pdf", "png")