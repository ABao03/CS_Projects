import g4p_controls.*;
int displayWidth = 1200; // Making these variables allows me to adjust the candlesticks based on screen size: especially handy when you're constantly zooming out! 
int displayHeight = 800;

// Price Movement Controllers
float volatility = 0;  // Controls the volatility of the stock: a higher volatility can create some crazy price jumps! Note that this is the same value that is adjustable on the slider
float currentSentiment = 0;  // Controls the current sentiment of the stock
float sentimentSlide = 0;  // Refers to the GUI slider for sentiment specifically, which is needed for the random stock price change
int zooms = 0;  // Controls how many times the animation has zoomed out: zoom-outs occur in response to very large candlesticks

// Display Variables
Boolean periodRandom = false;  // Allows the user to randomize the period length. I wanted to do a button, but buttons can't change already-decided global variables :(
int periodNumber = periodRandom ? round(random(1, 5)) : 1;  // Either defaults to 1 or randomizes the period: also suffers from the 'can't change an already-decided global variable' problem
int candleSpacing = 80;
int maxCandleSticks = displayWidth/2/candleSpacing*periodNumber;  // Controls when candlesticks start getting deleted to help alleviate burden on my poor abused CPU
ArrayList<CandleStick> CandleSticks = new ArrayList<CandleStick>();  // ArrayList that adds and removes candlesticks
int candleNumber = 0;  // Number of candlesticks total
int candlesThisPeriod = 0;  // Number of candlesticks in a period

void setup() {
  createGUI();
  size(displayWidth, displayHeight);
  background(255);
  frameRate(3);
}

void draw() {
  if (candleNumber - periodNumber > maxCandleSticks) { // Remove candlesticks when they go off the screen
    CandleSticks.remove(0);
    candleNumber--;
  }

  background(255);

  println(candlesThisPeriod);

  if (candlesThisPeriod + 1 == periodNumber) {  // If the number of candles this period is equal to the number of candles we want per period... 
    for (int i = 0; i < candleNumber; i++) {  // Offsets the candlesticks backwards 
      CandleSticks.get(i).currentPosition -= candleSpacing;  // Note that we need the conditional if because we want the price to update on the same coordinate, not be displaced every single time
    }
  } else if (candleNumber > 0) {  // But you see, the multiple-period update necessitates the removal of the most recently made candlestick: otherwise, we're gonna get doubles
    CandleSticks.remove(candleNumber - 1);  // Therefore, before we make a new candlestick, we have to remove that candlestick that the code is currently on
    candleNumber--;  // Subtract one from candle number
  }

  CandleSticks.add(new CandleStick());  // Add the new candlestick for this period here! Fun fact: this code was what taught me, in a very painful manner, that you can only see what appears after the draw function concludes running.
  candleNumber++;  // Add to both overall candle number and the local number of candles this period
  candlesThisPeriod++;  // Note that candlesticks don't actually get drawn here: that's the job of my method, drawCandleStick(). This code here merely generates the coordinates for the candlestick that will be drawn.

  if (zooms <= 5) { // A "zoom out" function that was a pain in the butt to code: don't let the zooms get too big or else you can't see the candlesticks anymore 
    if (CandleSticks.get(candleNumber - 1).open > displayHeight || CandleSticks.get(candleNumber - 1).open < 0) {  // If the candlestick is going outside of the bounds of the screen...
      for (int i = 0; i < candleNumber; i++) {  // Do a LOT of adjusting 
        CandleSticks.get(i).close /= 2;  // Halve the close position of the candle
        CandleSticks.get(i).close += displayHeight/4;  // Buffer from the screen top / bottom
        CandleSticks.get(i).candleHeight /= 2;  // Halve the candle height
        CandleSticks.get(i).candleWidth /= 2;  // Halve the candle width (gotta keep things proportional my dudes)
        CandleSticks.get(i).open /= 2;  // Halve the open position proportionally (I like that word) 
        CandleSticks.get(i).open += displayHeight/4;  // The other side of the candlestick needs to be buffered too! 
      }
      candleSpacing /= 2;  // Proportional spacing 
      candleSpacing += 5;  // But not too close 
      maxCandleSticks = displayWidth/2/candleSpacing;  // Adjust the maximum candlesticks so that 
      zooms++;  // Increase the number of zooms 
    }
  }

  for (int i = 0; i < candleNumber; i++) {  // Draw all the historical candlesticks
    CandleSticks.get(i).drawCandleStick();  // You see, this is where the stick actually gets drawn!
  }

  if (candlesThisPeriod >= periodNumber) {  // Reset local candlesThisPeriod in response to the displacement occuring after all the code has concluded
    candlesThisPeriod = 0;  // Resetting candlesThisPeriod too early would bungle everything, so it's saved for the end
  }
}
