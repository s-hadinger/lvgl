var month = ["Jan", "Febr", "March", "Apr", "May", "Jun", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]

def draw_event_cb(o,e)

    var dsc = lv.obj_draw_part_dsc(e.param)
    if dsc.part == lv.PART_TICKS && dsc.id == lv.CHART_AXIS_PRIMARY_X
        
        # dsc.text is defined char text[16], I must therefore convert the Python string to a byte_array
        import introspect
        dsc.text = month[dsc.value]
        # dsc.text = introspect.toptr(month[dsc.value])
    end
end

#
# Add ticks and labels to the axis and demonstrate scrolling
#

# Create a chart
chart = lv.chart(lv.scr_act())
chart.set_size(200, 150)
chart.center()
chart.set_type(lv.CHART_TYPE_BAR)
chart.set_range(lv.CHART_AXIS_PRIMARY_Y, 0, 100)
chart.set_range(lv.CHART_AXIS_SECONDARY_Y, 0, 400)
chart.set_point_count(12)
chart.add_event_cb(draw_event_cb, lv.EVENT_DRAW_PART_BEGIN, nil)

# Add ticks and label to every axis
chart.set_axis_tick(lv.CHART_AXIS_PRIMARY_X, 10, 5, 12, 3, true, 40)
chart.set_axis_tick(lv.CHART_AXIS_PRIMARY_Y, 10, 5, 6, 2, true, 50)
chart.set_axis_tick(lv.CHART_AXIS_SECONDARY_Y, 10, 5, 3, 4, true, 50)

# Zoom in a little in X
chart.set_zoom_x(800)

# Add two data series
ser1 = chart.add_series(lv.palette_lighten(lv.PALETTE_GREEN, 2), lv.CHART_AXIS_PRIMARY_Y)
ser2 = chart.add_series(lv.palette_darken(lv.PALETTE_GREEN, 2), lv.CHART_AXIS_SECONDARY_Y)

# Set the next points on 'ser1'
chart.set_next_value(ser1, 31)
chart.set_next_value(ser1, 66)
chart.set_next_value(ser1, 10)
chart.set_next_value(ser1, 89)
chart.set_next_value(ser1, 63)
chart.set_next_value(ser1, 56)
chart.set_next_value(ser1, 32)
chart.set_next_value(ser1, 35)
chart.set_next_value(ser1, 57)
chart.set_next_value(ser1, 85)
chart.set_next_value(ser1, 22)
chart.set_next_value(ser1, 58)

# Directly set points on 'ser2'
y2 = lv.coord_arr(ser2.y_points, 12)
y2[0] = 92
y2[1] = 71
y2[2] = 61
y2[3] = 15
y2[4] = 21
y2[5] = 35
y2[6] = 35
y2[7] = 58
y2[8] = 31
y2[9] = 53
y2[10] = 33
y2[11] = 73

chart.refresh()  # Required after direct set
