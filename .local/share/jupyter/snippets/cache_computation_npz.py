recalc = False

if recalc == True:
    ### create data1, data2, ... arrays
    outfile = open(data_dir + "data1_data2.npz", "w")
    np.savez(outfile, data1=data1, data2=data2)
    outfile.close()
else:
    infile = open(data_dir + "data1_data2.npz")
    npzfile = np.load(infile)
    data1 = npzfile["data1"]
    data2 = npzfile["data2"]
    infile.close()