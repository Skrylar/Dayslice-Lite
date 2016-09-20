project('dayslice-lite', 'vala', 'c')

gnome = import('gnome')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')
gio = dependency('gio-2.0')
canberra = dependency('libcanberra')
gcanberra = dependency('libcanberra-gtk3')

python = dependency('python3')
swig = find_program('swig')
swiggle = generator(swig,
    arguments: ['-python', '-o', '@OUTPUT@', '@INPUT@'],
    output: '@BASENAME@_wrap.c')

resource_xml = files ('src/dayslice-lite.gresources.xml')
resource = gnome.compile_resources ('dayslicelite', 'src/dayslice-lite.gresources.xml', source_dir: 'src', c_name: 'dayslicelite')

dayslice_files = ['src/main.vala', 'src/appwin.vala', 'src/fsm.vala', 'src/notifier.vala', 'src/timeprovider.vala', resource]

executable('dayslice-lite', dayslice_files,
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'posix', '--target-glib=2.38', '--gresources', resource_xml],
    c_args: ['-w'],
    link_args: ['-lm'],
    dependencies: [gobject, glib, gtk, gio, canberra, gcanberra])

minute_humanizer = executable ('test-minute-humanizer',
    'src/test_time_humanizer.vala', 'src/timehumanizer.vala',
    dependencies: [gobject, glib])
test ('minute_humanizer', minute_humanizer)

# instrumented binary for acceptance tests with robot framework
rube = swiggle.process ('src/robot.i')
library('dayslice_lite_roboticized', dayslice_files, 'src/robot.vala', rube,
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'posix', '--target-glib=2.38', '--gresources', resource_xml, '-D', 'ROBOTICIZED'],
    c_args: ['-w'],
    link_args: ['-lm'],
    name_prefix: '_',
    dependencies: [gobject, glib, gtk, gio, python, canberra, gcanberra])
