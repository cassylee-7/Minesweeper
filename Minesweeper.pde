import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 5;

private boolean END = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
}

public void setMines()
{
  mines = new ArrayList <MSButton>();
  while (mines.size() < NUM_BOMBS) {
    int r = (int)(Math.random()*20);
    int c = (int)(Math.random()*20);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{   
 
    if (END == true && isWon() == false)
      displayLosingMessage();
    else {
      if (isWon() == true) {
        println("winning condition met");
        displayWinningMessage();
        END = true;
      }
    }

    if (keyPressed) {
      if (key == 'b') {
        END = false;
        setMines();
        for (int r = 0; r < NUM_ROWS; r++) {
          for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].clicked = false;
            buttons[r][c].flagged = false;
            buttons[r][c].myLabel = "";
          }
        }
      }   
    }
}
 

public boolean isWon()
{ 
   int flaggedNum = 0;
   for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        if (buttons[r][c].flagged == true && mines.contains(buttons[r][c]))
          flaggedNum++;
      }
    }
   //println("Flagged bombs: " + flaggedNum + " / " + NUM_BOMBS);
   return flaggedNum == NUM_BOMBS;
}

public void displayLosingMessage()
{
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        if (mines.contains(buttons[r][c])) {
          fill (255, 0, 0);
          rect(c * 20, r * 20, 20, 20);
        }
      }
    }
    fill (255);
    text("YOU LOST", 200, 200);
}

public void displayWinningMessage()
{
    fill(255);
    text("WINNER", 200, 200);
}

public boolean isValid(int r, int c)
{
    if (r >= 0 && r < 20 && c >= 0 && c < 20)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = -1; r < 2; r++) {
      for (int c = -1; c < 2; c++) {
        if (isValid(row + r, col + c) == true 
        && mines.contains(buttons[row + r][col + c]))
          numMines++;
      }
    }
    if (mines.contains(buttons[row][col])) 
      return numMines - 1;
    return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    { 
      if (END == true)
        return;
        
      clicked = true;
    
      if (mouseButton == RIGHT) 
            flagged = true;
            clicked = true;
      
      if (mines.contains(this) && this.clicked == true && this.flagged == false)
        END = true;

      for (int r = -1; r < 2; r++) {
        for (int c = -1; c < 2; c++) {
          if (flagged == false 
            && isValid(myRow + r, myCol + c) == true 
            && countMines(myRow, myCol) == 0 
            && buttons[myRow + r][myCol + c].clicked == false)
              buttons[myRow + r][myCol + c].mousePressed();
          if (mines.contains(buttons[myRow][myCol]))
            myLabel = "";
          else if (countMines(myRow, myCol) == 1)
            myLabel = "1";
          else if (countMines(myRow, myCol) == 2)
            myLabel = "2";
          else if (countMines(myRow, myCol) == 3)
            myLabel = "3";
          else if (countMines(myRow, myCol) == 4)
            myLabel = "4";
          else if (countMines(myRow, myCol) == 5)
            myLabel = "5";
          else if (countMines(myRow, myCol) == 6)
            myLabel = "6";
          else if (countMines(myRow, myCol) == 7)
            myLabel = "7";
          else if (countMines(myRow, myCol) == 8)
            myLabel = "8";
        }
      }
    }
    
    public void draw () 
    {    
        if (END == true)
          return;
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public String getLabel() {
        return myLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
