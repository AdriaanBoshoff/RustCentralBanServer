object WebModuleActions: TWebModuleActions
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'rustBans'
      PathInfo = '/api/rustBans/*'
      OnAction = WebModuleActionsrustBansAction
    end
    item
      Name = 'AddRustBans'
      PathInfo = '/api/addRustBans'
    end>
  Height = 230
  Width = 415
end
