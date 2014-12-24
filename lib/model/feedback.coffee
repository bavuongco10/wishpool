class Feedback
  constructor: (doc) ->
    _.extend(@, doc)
  widget: ->
    Widgets.findOne(@widgetId)

share.Transformations.feedback = _.partial(share.transform, Feedback)

@Feedbacks = new Mongo.Collection("feedbacks",
  transform: if Meteor.isClient then share.Transformations.feedback else null
)

feedbackPreSave = (userId, changes) ->

Feedbacks.before.insert (userId, feedback) ->
  feedback._id ||= Random.id()
  now = new Date()
  _.defaults(feedback,
    text: ""
    label: ""
    placeholder: ""
    sourceUrl: ""
    sourceUserName: ""
    sourceUserEmail: ""
    sourceUserAvatarUrl: ""
    sourceUserId: ""
    isStarred: false
    isArchived: false
    domainId: null
    accessibleBy: []
    updatedAt: now
    createdAt: now
  )
  feedbackPreSave.call(@, userId, feedback)
  true

Feedbacks.before.update (userId, feedback, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  feedbackPreSave.call(@, userId, modifier.$set || {})
  true
