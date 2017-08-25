# detect-nerve
Medical image analysis, to find a nerve tissue and get its location in an image using Hog+SVM method.
Training data and testing data is available on [nerve-detect-data](http://pan.baidu.com/s/1ge9Ktz1) ,welcome to download.

My English is so poor, so next I will write in Chinese.(^o^)!
# introduction
与单纯的全身麻醉相比，局部麻醉具有明显的优势，包括降低并发症发生率和死亡率，提供良好的术后镇痛等，而且性价比明显更好。尽管有这些优势，但是局部麻醉并没有像全身麻醉一样普及并获得同样地位，相对于全身麻醉几乎百分百的成功率，局部麻醉即使由熟练的麻醉师进行操作，也存在较大失败风险。

导致局部麻醉失败的一个重要原因是传统定位技术不够精确，并且可能误导操作。传统神经定位技术（例如神经刺激法）依赖于以体表标识为基本依据的解剖定位。由于人体解剖存在差异，即使经验丰富的临床麻醉师也难免定位失败。
近年来，利用超声成像引导的麻醉辅助手段日益成熟。通过超声成像，麻醉师能够直接观测到神经、穿刺针以及麻醉药物的扩散。因此，超声引导的麻醉方法越来广泛地应用到局部麻醉中。
![Fig](https://github.com/FieldRen/detect-nerve/blob/master/image/detectNerve.JPG)

受麻醉师对超声影像的熟悉程度，操作扫描位置和手法、成像角度以及清晰度等诸多因素的影像，麻醉师往往要经过很长时间的培训才能够掌握超声引导麻醉技术。这大大限制了超声引导这一非常有前途的技术在局部麻醉领域推广。如果可以利用信息处理技术，实现对超声影响中神经区域的自动识别，必将极大地方便医生操作，降低对于麻醉师的要求，提高局部麻醉水平。
这个项目的任务就从这里开始。对原始超声影像数据进行分析，构造标识出其中神经区域的方法，并通过实际数据检验所提出方法的有效性。
