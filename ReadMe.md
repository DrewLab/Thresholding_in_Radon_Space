## Thresholding in Radon Space (TiRS) for vessel cross-sectional area


Two-photon imaging allows the measurement of size changes in penetrating arterioles and ascending venules.  However, the cross-sectional shape of these vessels will change when dilating or constricting [^1] [^2] [^3] [^4].  Because of these shape changes, typical diameter measurement approaches, such as the full-width at half-maximum (FWHM) that depend on a single diameter axis will generate erroneous results.  Other methods, such as thresholding, are non-robust to changes in noise or intensity.   To circumvent these problems in detecting vessel diameters, we developed the Thresholded in Radon Space (TiRS) algorithm, which is able to robustly detect diameter of penetrating vessels from two-photon microscopy.  The TiRS algorithm effectively determines the FWHM at all angles, yielding a more robust and accurate diameter than other methods.

The paper[^5] describing the TiRS method in detail is freely available [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4083381/):

The demo Matlab code here works on .tif stacks, which can be exported from most 2-photon acquisition programs.  


A comparison of the robustness of the TiRS, FWHM and thresholding methods to noise:

![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4083381/bin/jcbfm201467f3.jpg)


The TiRS method allows unbiased measures of vessel diameter form real data:
![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4083381/bin/jcbfm201467f6.jpg)

[^1]:Van Citters RL, Wagner BM, Rushmer RF. Architecture of small arteries during vasoconstriction. *Circ Res*. 1962;10:668–675.

[^2]:Van Citters RL. Occlusion of lumina in small arterioles during vasoconstriction. *Circ Res*. 1966;18:199–204.

[^3]:Greensmith JE, Duling BR. Morphology of the constricted arteriolar wall: physiological implications. *Am J Physiol*. 2003;247:H687–H698.

[^4]:Steelman SM, Wu Q, Wagner HP, Yeh AT, Humphrey JD. Perivascular tethering modulates the geometry and biomechanics of cerebral arterioles. *J Biomech*. 2010;43:2717–2721.

[^5]:Gao YR, Drew PJ, Determination of vessel cross-sectional area by thresholding in Radon space, *Journal of Cerebral Blood Flow Metabolism* 2014, 34(7):1180-7.
