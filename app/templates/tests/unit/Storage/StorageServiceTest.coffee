'use strict'

describe 'StorageService', ->

    tom = {
            name: 'Tom Waits'
            occupation: 'Legendary Musician'
            discography: [
                {
                    title: 'Asylum Years'
                    year: 1973
                    songs: [
                        {
                            title: "Diamonds on My Windshield"
                            duration: '3:08'
                        }
                        {
                            title: "(Looking For) The Heart of Saturday Night"
                            duration: '3:55'
                        }
                        {
                            title: "Martha"
                            duration: '4:29'
                        }
                        {
                            title: "The Ghosts of Saturday Night (After Hours at Napoleone's Pizza House)"
                            duration: '3:14'
                        }
                        {
                            title: "Grapefruit Moon"
                            duration: '4:49'
                        }
                        {
                            title: "Small Change"
                            duration: '5:05'
                        }
                        {
                            title: "Burma Shave"
                            duration: '6:33'
                        }
                        {
                            title: "I Never Talk to Strangers"
                            duration: '3:41'
                        }
                        {
                            title: "Tom Traubert's Blues"
                            duration: '6:34'
                        }
                        {
                            title: "Blue Valentines"
                            duration: '5:54'
                        }
                        {
                            title: "Potter's Field (Alcivar, Waits)"
                            duration: '8:44'
                        }
                        {
                            title: "Kentucky Avenue"
                            duration: '4:51'
                        }
                        {
                            title: "Somewhere (From West Side Story) (Leonard Bernsten, Stephen Sondheim)"
                            duration: '3:53'
                        }
                        {
                            title: "Ruby's Arms"
                            duration: '5:35'
                        }
                    ]
                }
            ]
        }

    store = null

    beforeEach ->
        module '<%= name %>'
        inject ($injector)-> store = $injector.get 'StorageService'
        # clear any existing data in local storage
        window.localStorage.clear()


    it 'stores and retrieves strings', ->
        store.put 'string', 'value'
        retrieved = store.get('string')

        expect(retrieved).toEqual 'value'
        expect(typeof retrieved).toEqual 'string'


    it 'stores and retireves integers', ->
        store.put 'int', 1234567890
        retrieved = store.get 'int'

        expect(retrieved).toEqual 1234567890
        expect(typeof retrieved).toEqual 'number'


    it 'stores and retrieves array', ->
        value = [1, 2, 3, 4]
        store.put 'arr', value

        retrieved = store.get 'arr'

        expect(retrieved).toEqual value
        expect(typeof retrieved).toEqual 'object'
        expect(retrieved instanceof Array).toBeTruthy()


    it 'stores and retrieves objects', ->
        store.put 'tom', tom
        retrieved = store.get 'tom'

        expect(retrieved).toEqual tom
        expect(typeof retrieved).toEqual 'object'
        expect(retrieved instanceof Object).toBeTruthy()


    it 'stores badass values in both keys and values', ->
        store.put null, null
        null_retrieved = store.get null
        expect(null_retrieved).toBeNull()

        store.put undefined, undefined
        undefined_retrieved = store.get undefined
        expect(undefined_retrieved).toBeUndefined()


    it 'flushes the storage', ->
        store.put 'something', 'something'
        store.put 'another', 'thing'
        store.put 'more', 'more'
        store.put 'even', 'more'
        store.put 'than', 'before'

        store.flush()

        expect(store.get('something')).toBeUndefined()
        expect(store.get('another')).toBeUndefined()
        expect(store.get('more')).toBeUndefined()
        expect(store.get('even')).toBeUndefined()
        expect(store.get('than')).toBeUndefined()