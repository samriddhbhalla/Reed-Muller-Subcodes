function [RecWord]=makeErrorawgn(CodeWord,snr)
CodeWord=(CodeWord*2)-1;
Noise=awgn(CodeWord,snr);
RecWord=CodeWord+Noise;

end