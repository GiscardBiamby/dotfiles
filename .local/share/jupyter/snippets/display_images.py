from IPython.core.display import HTML, Markdown
def show_samples(df: pd.DataFrame, n_samples: int = 20):
    df_random = df.sample(n=n_samples)

    for idx, img_row in df_random.iterrows():
        print("-" * 100)
        img = pil_img.open(img_row["full_path"])
        img.thumbnail((1080, 640), pil_img.NEAREST)
        display(img)
        print(
            "Predicted: ",
            img_row["filtering_class_id"],
            img_row["filtering_class_name"],
        )
        print("")


show_samples(df_preds, 50)