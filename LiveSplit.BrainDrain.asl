// Define the executable and variables
state("BRAINPC") {
    int timer : "BRAINPC.EXE", 0xDD7C;
    int level : "BRAINPC.EXE", 0xD9F0;
    int status : "BRAINPC.EXE", 0xDD80;
}

// Variables
init {
    vars.inGame = current.status == vars.inGame
    vars.levelChanged = current.level != old.level
    vars.timerStarted = current.timer == 90
}

// Auto-reset, useful when already in a run
reset {
    if (current.level == 1) {
        if (vars.levelChanged) {
            print("Restarting game from another level");
            return true;
        }

        if (vars.timerStarted && current.timer != old.timer) {
            print("Restarting game from level 1");
            return true;
        }
    }
}

start {
    if (vars.inGame && vars.timerStarted && current.level == 1) {
        print("Starting a new game");
        return true;
    }
}

split {
    if (current.status != old.status && !vars.inGame) {
        print("From a level back to main menu AKA Game over")
        return true;
    }

    if (vars.levelChanged) {
        print("Level changed");
        return true;
    }
}
