module.exports = (app)->
    ###*
     * Reverse a string and optionally
     * make it all uppercase when uppercase is set to true.
     *
     * @param  {string} input
     * @param  {boolean} uppercase
     * @return {string}
    ###
    app.filter 'reverse', -> (input, uppercase)->
        out = ''
        out = input.charAt(i) + out for char, i in input
        out = out.toUpperCase() if uppercase
        return out
