// Define the executable and variables
state("BRAINPC") {
    int timer : "BRAINPC.EXE", 0xDD7C;
    int level : "BRAINPC.EXE", 0xD9F0;
    int status : "BRAINPC.EXE", 0xDD80;
}

startup {
    // Needed in `update` to reset an `Ended` timer
    vars.TimerModel = new TimerModel { CurrentState = timer };
}

start {
    if (vars.gameStarted) {
        print("New game");
        return true;
    }
}

split {
    if (current.status != 1) {
        print("Game Over");
        return true;
    }

    if (vars.levelChanged) {
        print("Split");
        return true;
    }
}

reset {
    if (current.level == 1) {
        if (vars.levelChanged) {
            print("Restarting from another level");
            return true;
        }

        if (current.timer > old.timer) {
            print("Restarting from first level");
            return true;
        }
    }
}

update {
    vars.levelChanged = current.level != old.level;
    vars.gameStarted = current.status == 1 && current.level == 1 && current.timer > old.timer;

    if (timer.CurrentPhase == TimerPhase.Ended && settings.ResetEnabled && vars.gameStarted) {
        print("Restarting from main menu");
        vars.TimerModel.Reset();  // Reset `Ended` timer
    }
}
