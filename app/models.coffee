###
    Light-weight models to wrap data.    
###

{Firebase, FIREBASE_URL} = require("./firebase")

_ = require("underscore")

class Model
    constructor: (@attributes={}, @options) ->
        @ref = new Firebase(FIREBASE_URL+'/writing/'+@attributes.id)
    get: (key) ->
        @attributes[key]
    set: (key, value) ->
        obj = {}
        obj[key] = value
        @ref.update obj
    toJSON: ->
        obj = _.clone @attributes
        obj.modelName = "Post"
        obj


class Collection
    name: "Collection"
    constructor: (models) ->
        @collectionName = @name
        @models = _(models).map (attributes) =>
            model = @model || Model
            new model(attributes)

collectionMethodNames = ['forEach', 'each', 'map', 'collect', 'reduce', 'foldl',
    'inject', 'reduceRight', 'foldr', 'find', 'detect', 'filter', 'select',
    'reject', 'every', 'all', 'some', 'any', 'include', 'contains', 'invoke',
    'max', 'min', 'toArray', 'size', 'first', 'head', 'take', 'initial', 'rest',
    'tail', 'drop', 'last', 'without', 'difference', 'indexOf', 'shuffle',
    'lastIndexOf', 'isEmpty', 'chain', 'sample']

for name in collectionMethodNames
    do (name) ->
        Collection.prototype[name] = ->
            args = [].slice.call(arguments)
            args.unshift(this.models)
            _[name].apply(_, args)

modelMethods = ['keys', 'values', 'pairs', 'invert', 'pick', 'omit']
for name in modelMethods
    do (name) ->
        Model.prototype[name] = ->
            args = [].slice.call(arguments)
            args.unshift(this.models)
            _[name].apply(_, args)

class Post extends Model

class PostCollection extends Collection
    name: "PostCollection"
    model: Post


@Model = Model
@Collection = Collection
@Post = Post
@PostCollection = PostCollection














