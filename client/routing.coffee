Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

Router.map ->
  @route "index",
    path: "/"
  @route "convert",
    path: "/convert/:slug"
    template: "convert"
    data: ->
      {
        tool: share.Tools.findOne({slug: @params.slug})
      }

Router.onAfterAction ->
  share.setPageTitle("Wishpool = Instant customer feedback with ♥", false)

Router.onAfterAction ->
  share.debouncedSendPageview()

share.setPageTitle = (title, appendSiteName = true) ->
  if appendSiteName
    title += " - Wishpool"
  if Meteor.settings.public.isDebug
    title = "(D) " + title
  document.title = title