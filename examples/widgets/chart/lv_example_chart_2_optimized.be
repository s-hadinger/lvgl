# this example is unfortunately very slow in Berry
var line_mask_param = lv.draw_mask_line_param()
var fade_mask_param = lv.draw_mask_fade_param()
var coords = lv.area(), a = lv.area()
var draw_rect_dsc = lv.draw_rect_dsc()
# the following are kept globally to avoid object reallocation
var dsc
var p1, p2
var line_dsc
var draw_ctx


def draw_event_cb(obj, e)
    def cast(bytes_class, ptr, curr_value)
        if curr_value
            curr_value._change_buffer(ptr)
        else
            curr_value = bytes_class(ptr)
        end
        return curr_value
    end

    # Add the faded area before the lines are drawn
    dsc = cast(lv.obj_draw_part_dsc, e.param, dsc)

    if dsc.part != lv.PART_ITEMS
        return
    end

    var nullptr = introspect.toptr(0)
    if int(dsc.p1) == 0 || int(dsc.p2) == 0
        return
    end

    # Add a line mask that keeps the area below the line
    # var line_mask_param = lv.draw_mask_line_param()
    p1 = cast(lv.point, dsc.p1, p1)
    p2 = cast(lv.point, dsc.p2, p2)
    lv.draw_mask_line_points_init(line_mask_param, p1.x, p1.y, p2.x, p2.y, lv.DRAW_MASK_LINE_SIDE_BOTTOM)

    var line_mask_id = lv.draw_mask_add(line_mask_param, nil)
    # # Add a fade effect: transparent bottom covering top
    var h = obj.get_height()
    # var fade_mask_param = lv.draw_mask_fade_param()
    # var coords = lv.area()

    obj.get_coords(coords)
    lv.draw_mask_fade_init(fade_mask_param, coords, lv.OPA_COVER, coords.y1 + h / 8, lv.OPA_TRANSP, coords.y2)
    var fade_mask_id = lv.draw_mask_add(fade_mask_param, nil)

    # Draw a rectangle that will be affected by the mask
    # var draw_rect_dsc = lv.draw_rect_dsc()
    lv.draw_rect_dsc_init(draw_rect_dsc)
    draw_rect_dsc.bg_opa = lv.OPA_20
    line_dsc = cast(lv.lv_draw_line_dsc, dsc.line_dsc, line_dsc)
    draw_rect_dsc.bg_color = line_dsc.color

    # var a = lv.area()
    a.x1 = p1.x
    a.x2 = p2.x - 1
    a.y1 = (p1.y < p2.y) ? p1.y : p2.y
    coords = lv.area()
    obj.get_coords(coords)
    a.y2 = coords.y2
    draw_ctx = cast(lv.draw_ctx, dsc.draw_ctx, draw_ctx)
    lv.draw_rect(draw_ctx, draw_rect_dsc, a)

    # # Remove the masks
    lv.draw_mask_remove_id(line_mask_id)
    lv.draw_mask_remove_id(fade_mask_id)
end

var chart1  # need to declare global before function
var ser1, ser2

def add_data(timer)
    var cnt = 0
    chart1.set_next_value(ser1, lv.rand(20, 90))

    if cnt % 4 == 0
        chart1.set_next_value(ser2, lv.rand(40, 60))
    end

    cnt +=1
end

#
# Add a faded area effect to the line chart
#

# Create a chart1
chart1 = lv.chart(lv.scr_act())
chart1.set_size(200, 150)
chart1.center()
chart1.set_type(lv.CHART_TYPE_LINE)    # Show lines and points too

chart1.add_event_cb(draw_event_cb, lv.EVENT_DRAW_PART_BEGIN, nil)
chart1.set_update_mode(lv.CHART_UPDATE_MODE_CIRCULAR)

# Add two data series
ser1 = chart1.add_series(lv.palette_main(lv.PALETTE_RED), lv.CHART_AXIS_PRIMARY_Y)
ser2 = chart1.add_series(lv.palette_main(lv.PALETTE_BLUE), lv.CHART_AXIS_SECONDARY_Y)

for i:0..9
    chart1.set_next_value(ser1, lv.rand(20, 90))
    chart1.set_next_value(ser2, lv.rand(30, 70))
end

#timer = lv.timer_create(add_data, 200, nil)    # lv.timer_create is not supported in Berry and must be set in steps as below
timer = lv.timer_create_basic()
timer.set_period(200)
timer.set_cb(add_data)
