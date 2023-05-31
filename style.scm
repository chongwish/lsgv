(lsgv-parse '($ rainbow-halo-node
                :shape "ellipse"
                :override (rainbow-color)
                :fontcolor-ratio 0.8
                :filled-color-ratio 1.6
                :fix-fontcolor-blue-offset #x90
                :style "filled,radial"))

(lsgv-parse '($ rainbow-node
                :shape "ellipse"
                :fontcolor #xffffff
                :override (rainbow-color)
                :style "filled"))

(lsgv-parse '($ rainbow-simple-node
                :shape "ellipse"
                :fontcolor-ratio 1
                :override (rainbow-color)))

(lsgv-parse '($ rainbow-halo-line
                :style "tapered"
                :penwidth "5"
                :arrowhead "none"
                :relation parent))

(lsgv-parse '($ rainbow-line
                :relation parent))

(lsgv-parse '($ project-core-node
                :filled-color #xffff00
                :color #x008b00
                :fontcolor #x006400
                :shape "circle"
                :style "filled,radial"))

(lsgv-parse '($ project-feature-node
                :color #x543005
                :filled-color #x8c510a
                :fontcolor #xfddbc7
                :shape "egg"
                :style "filled,radial"))

(lsgv-parse '($ project-component-node
                :color #xff1493
                :filled-color #x9370db
                :fontcolor #x8b0000
                :shape "component"
                :style "filled,radial"))

(lsgv-parse '($ project-package-node
                :filled-color #xffff00
                :color #xffa500
                :fontcolor #xff4500
                :shape "house"
                :style "filled,radial"))

(lsgv-parse '($ project-folder-node
                :filled-color #x00c5cd
                :color #x63b8ff
                :fontcolor #x045a8d
                :shape "folder"
                :style "filled,radial"))

(lsgv-parse '($ project-function-node
                :color #x762a83
                :filled-color #x9e9ac8
                :fontcolor #xcccccc
                :shape "parallelogram"
                :style "filled,radial"))

(lsgv-parse '($ project-test-node
                :filled-color #x008b00
                :color #x8b0000
                :fontcolor #xeeeeee
                :shape "hexagon"
                :style "filled,radial"))

(lsgv-parse '($ project-note-node
                :color #xc0c0c0
                :fontcolor #x000000
                :shape "note"
                :style "filled,radial"))

(lsgv-parse '($ project-data-node
                :filled-color #x67a9cf
                :color #x016450
                :fontcolor #xe5d8bd
                :shape "cylinder"
                :style "filled,radial"))

(lsgv-parse '($ project-depend-line
                :relation child
                :style "tapered"
                :arrowhead "none"
                :penwidth "5"))

(lsgv-parse '($ project-derive-line
                :relation parent
                :style "tapered"
                :arrowhead "none"
                :penwidth "5"))

(lsgv-parse '($ project-contain-line
                :relation parent))

(lsgv-parse '($ project-use-line
                :relation child
                :penwidth "3"
                :style "dotted"))

(lsgv-parse '($ project-mean-line
                :relation child
                :arrowhead "none"
                :style "dashed"))
