Class {
	#name : #BPCmpPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPCmpPageBuilder class >> endAddress [
	^ 16rE40000 - 1
]

{ #category : #accessing }
BPCmpPageBuilder class >> startAddress [
	^ 16rE30000
]

{ #category : #writing }
BPCmpPageBuilder >> writeBankOn: aByteArray [
	self startAddress to: self endAddress do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (x = y ifTrue: [ 3 ] ifFalse: [ 0 ]) ]
]
