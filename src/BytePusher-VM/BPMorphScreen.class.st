Class {
	#name : #BPMorphScreen,
	#superclass : #Morph,
	#category : #'BytePusher-VM-MorphDriver'
}

{ #category : #drawing }
BPMorphScreen >> drawOn: aCanvas [

	aCanvas fillRectangle: self bounds fillStyle: self fillStyle borderStyle: self borderStyle
]

{ #category : #geometry }
BPMorphScreen >> height [
	^ 256
]

{ #category : #geometry }
BPMorphScreen >> width [
	^ 256
]
