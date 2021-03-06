Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  yieldTemplates:
    "header": {to: "header"}
    "footer": {to: "footer"}

Router.map ->
  @route "index",
    path: "/"
    data: ->
      {
        starred: Feedbacks.find({isStarred: true}, {sort: {createdAt: -1}})
        new: Feedbacks.find({isArchived: false, isStarred: false}, {sort: {createdAt: -1}})
        archived: Feedbacks.find({isArchived: true, isStarred: false}, {sort: {createdAt: -1}})
      }
  @route "pricing",
    path: "/pricing"
    layoutTemplate: "cleanLayout"
  @route "contactus",
    path: "/contactus"
    layoutTemplate: "cleanLayout"
  @route "features",
    path: "/features"
    layoutTemplate: "cleanLayout"
  @route "domainAdd",
    path: "/domain/add"
  @route "domain",
    path: "/domain/:_id"
    data: ->
      {
        domain: Domains.findOne(@params._id)
      }
  @route "widget",
    path: "/widget/:_id"
    data: ->
      {
        widget: Widgets.findOne(@params._id)
      }
  @route "/autologin/:token",
    name: "autologin"
    onBeforeAction: ->
      Meteor.loginWithToken(@params.token)
      share.autologinDetected = true
      Router.go("index")

Router.onBeforeAction ->
  if Meteor.userId()
    @next()
  else
    @render(null, {to: "header"})
    @render(null, {to: "footer"})
    @render("welcome")
, except: ["features", "contactus", "pricing"]

Router.onAfterAction ->
  share.setPageTitle("Wishpool = Instant customer feedback with ♥", false)

Router.onAfterAction share.sendPageview

Router.onRun -> # try fixing the lagging scroll issue when logging in from mobile devices while having already scrolled down the page
  $(window).scrollTop(0)
  @next()

share.setPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " - Wishpool"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  document.title = title
