Class {
	#name : #BPIOMorphicDriver,
	#superclass : #BPIODriver,
	#instVars : [
		'form',
		'imageMorph',
		'colorArray'
	],
	#category : #BytePusher
}

{ #category : #accessing }
BPIOMorphicDriver >> colorArrayAt: aByte [
	"Returns the color corresponding to the 8-bits color encoded in aByte provided as argument."
	^ colorArray at: aByte + 1
]

{ #category : #rendering }
BPIOMorphicDriver >> fillFormFrom: aByteArray [
	| byteStream bitBlt |
	byteStream := aByteArray readStream.
	bitBlt := BitBlt bitPokerToForm: form.
	0 to: 255 do: [ :y |
		0 to: 255 do: [ :x |
			bitBlt pixelAt: x@y put: (self colorArrayAt: byteStream next)
			"form pixelValueAt: x @ y put: (self colorArrayAt: byteStream next)" ] ].
]

{ #category : #accessing }
BPIOMorphicDriver >> form [
	^ form
]

{ #category : #accessing }
BPIOMorphicDriver >> imageMorph [
	^ imageMorph
]

{ #category : #initialization }
BPIOMorphicDriver >> initialize [
	super initialize.
	self initializeColorArray.
	form := Form extent: 256@256 depth: 8.
	imageMorph := ImageMorph new
]

{ #category : #initialization }
BPIOMorphicDriver >> initializeColorArray [
	colorArray := ByteArray new: 256.
	"Compute the mapping between bytepusher's colors encoding and Pharo's colors encoding."
	0 to: 215 do: [ :colorValue |
		|blue green red|
		blue := (colorValue % 6).
		green := (((colorValue - blue) // 6) % 6).
		red := (((colorValue - blue - (6 * green)) // 36) % 6).
		colorArray at: colorValue + 1 put: ((Color r: red * 16r33 / 255 g: green * 16r33 / 255 b: blue * 16r33 / 255) pixelValueForDepth: 8) ].
	"Bytepusher only support 216 colors, > 215 are considered as black."
	216 to: 255 do: [ :colorValue |
		colorArray at: colorValue + 1 put: (Color black pixelValueForDepth: 8) ]
]

{ #category : #rendering }
BPIOMorphicDriver >> renderDisplayFrame: aByteArray [
	self fillFormFrom: aByteArray.
	imageMorph form: self form
]
