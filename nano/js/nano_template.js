
var NanoTemplate = function () {

    var _templateData = {};

    var _templates = {};
    var _compiledTemplates = {};
	
	var _helpers = {};

    var init = function () {
        // We store templateData in the body tag, it's as good a place as any
		_templateData = $('body').data('templateData');

		if (_templateData == null)
		{
			alert('错误：模板数据未能正确加载。');
		}

		loadNextTemplate();
    };

    var loadNextTemplate = function () {
        // we count the number of templates for this ui so that we know when they've all been rendered
        var templateCount = Object.size(_templateData);

        if (!templateCount)
        {
            $(document).trigger('templatesLoaded');
            return;
        }

        // load markup for each template and register it
        for (var key in _templateData)
        {
            if (!_templateData.hasOwnProperty(key))
            {
                continue;
            }

            $.when($.ajax({
                    url: _templateData[key],
                    cache: false,
                    dataType: 'text'
                }))
                .done(function(templateMarkup) {

                    templateMarkup += '<div class="clearBoth"></div>';

                    try
                    {
                        NanoTemplate.addTemplate(key, templateMarkup);
                    }
                    catch(error)
                    {
                        alert('错误：界面加载失败：' + error.message);
                        return;
                    }

                    delete _templateData[key];

                    loadNextTemplate();
                })
                .fail(function () {
                    alert('错误：模板' + key + '（' + _templateData[key] + '）加载失败！');
                });

            return;
        }
    }

    var compileTemplates = function () {

        for (var key in _templates) {
            try {
                _compiledTemplates[key] = doT.template(_templates[key], null, _templates)
            }
            catch (error) {
                alert(error.message);
            }
        }
    };

    return {
        init: function () {
            init();
        },
        addTemplate: function (key, templateString) {
            _templates[key] = templateString;
        },
        templateExists: function (key) {
            return _templates.hasOwnProperty(key);
        },
        parse: function (templateKey, data) {
            if (!_compiledTemplates.hasOwnProperty(templateKey) || !_compiledTemplates[templateKey]) {
                if (!_templates.hasOwnProperty(templateKey)) {
                    alert('错误：模板“' + templateKey + '”在_compiledTemplates中不存在！');
                    return '<h2>模板错误（模板不存在）</h2>';
                }
                compileTemplates();
            }
            if (typeof _compiledTemplates[templateKey] != 'function') {
                alert(_compiledTemplates[templateKey]);
                alert('错误：模板“' + templateKey + '”编译失败！');
                return '<h2>模板错误（编译失败）</h2>';
            }
            return _compiledTemplates[templateKey].call(this, data['data'], data['config'], _helpers);
        },
		addHelper: function (helperName, helperFunction) {
			if (!jQuery.isFunction(helperFunction)) {
				alert('NanoTemplate.addHelper无法添加' + helperName + '，因为它不是函数。');
				return;	
			}
			
			_helpers[helperName] = helperFunction;
		},
		addHelpers: function (helpers) {		
			for (var helperName in helpers) {
				if (!helpers.hasOwnProperty(helperName))
				{
					continue;
				}
				NanoTemplate.addHelper(helperName, helpers[helperName]);
			}
		},
		removeHelper: function (helperName) {
			if (helpers.hasOwnProperty(helperName))
			{
				delete _helpers[helperName];
			}	
		}
    }
}();
 

