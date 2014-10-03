function [ hchange ] = hchange( ah, h, bh )
hchange = ah * (1-h) - bh * h;

end

