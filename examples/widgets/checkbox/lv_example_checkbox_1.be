def event_handler(obj, e)
    var code = e.code
    if code == lv.EVENT_VALUE_CHANGED
        var txt = obj.get_text()
        var state
        if obj.get_state() & lv.STATE_CHECKED
            state = "Checked"
        else
            state = "Unchecked"
        end
        print(txt + ":" + state)
    end
end


lv.scr_act().set_flex_flow(lv.FLEX_FLOW_COLUMN)
lv.scr_act().set_flex_align(lv.FLEX_ALIGN_CENTER, lv.FLEX_ALIGN_START, lv.FLEX_ALIGN_CENTER)

cb1 = lv.checkbox(lv.scr_act())
cb1.set_text("Apple")
cb1.add_event_cb(event_handler, lv.EVENT_ALL, nil)

cb2 = lv.checkbox(lv.scr_act())
cb2.set_text("Banana")
cb2.add_state(lv.STATE_CHECKED)
cb2.add_event_cb(event_handler, lv.EVENT_ALL, nil)

cb3 = lv.checkbox(lv.scr_act())
cb3.set_text("Lemon")
cb3.add_state(lv.STATE_DISABLED)
cb3.add_event_cb(event_handler, lv.EVENT_ALL, nil)

cb4 = lv.checkbox(lv.scr_act())
cb4.add_state(lv.STATE_CHECKED | lv.STATE_DISABLED)
cb4.set_text("Melon")
cb4.add_event_cb(event_handler, lv.EVENT_ALL, nil)

cb4.update_layout()
