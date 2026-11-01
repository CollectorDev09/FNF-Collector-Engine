function onCreate()
{
    intro = parseRandomIntro();
}

function onBeatHit(curBeat:Int)
{
    if (curBeat == 1)
    {
        createText(["CollectorDev"]);
    }

    if (curBeat == 3)
    {
        addText("Presents");
    }

    if (curBeat == 4)
    {
        clearText();
    }

    if (curBeat == 5)
    {
        createText(["Not Associated", "With"]);
    }

    if (curBeat == 7)
    {
        addText("Newgrounds");
    }

    if (curBeat == 8)
    {
        clearText();
    }

    if (curBeat == 9)
    {
        createText([intro[0]]);
    }

    if (curBeat == 11)
    {
        addText(intro[1]);
    }

    if (curBeat == 12)
    {
        clearText();
    }

    if (curBeat == 13)
    {
        createText(["FNF"]);
    }

    if (curBeat == 14)
    {
        addText("Collector");
    }

    if (curBeat == 15)
    {
        addText("Engine");
    }
}