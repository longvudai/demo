var highlighter;

var initialDoc;

class HighlightObject {
    constructor(id, start, end, color) {
        this.id = id
        this.start = start
        this.end = end
        this.color = color
    }
}

class SerializedObject {
    constructor(highlights, currentHighlight) {
        this.highlights = highlights
        this.currentHighlight = currentHighlight
    }
}

window.onload = function () {
    rangy.init();

    highlighter = rangy.createHighlighter();

    highlighter.addClassApplier(rangy.createClassApplier("orange", {
        tagNames: ["span"]
    }));
    highlighter.addClassApplier(rangy.createClassApplier("pink", {
        tagNames: ["span"]
    }));
    highlighter.addClassApplier(rangy.createClassApplier("cyan", {
        tagNames: ["span"]
    }));
};

function clearSelection() {
    if (window.getSelection) { window.getSelection().removeAllRanges(); }
    else if (document.selection) { document.selection.empty(); }
}

function highlightSelectedTextWithColor(color) {
    rangy.getSelection().trim()
    let data = highlighter.getHighlightsInSelection()
    let newHighlights = highlighter.highlightSelection(color, { "exclusive": false });

    filteredData = data.filter(hl => hl.classApplier.className != color)
    if (filteredData.length > 0) {
        highlighter.removeHighlights(filteredData)
    }

    let currentHighlight = newHighlights[0]
    currentHighlight.getRange().select()
    rangy.getSelection().trim()

    let object = new SerializedObject(
        getHighlights(),
        new HighlightObject(
            currentHighlight.id,
            currentHighlight.characterRange.start,
            currentHighlight.characterRange.end,
            currentHighlight.classApplier.className
        )
    )
    window.webkit.messageHandlers.serialize.postMessage(JSON.stringify(object));
}

function getHighlights() {
    return highlighter.highlights.map(x => {
            return new HighlightObject(
                x.id,
                x.characterRange.start,
                x.characterRange.end,
                x.classApplier.className
            )
        })
}

function removeAllHighlights() {
    highlighter.removeAllHighlights()
    clearSelection()
}

function erase() {
    highlighter.unhighlightSelection();
    let object = new SerializedObject(
        getHighlights()
    )
    window.webkit.messageHandlers.erase.postMessage(JSON.stringify(object));
}
