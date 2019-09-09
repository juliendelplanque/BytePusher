Class {
	#name : #BPAddPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #writing }
BPAddPageBuilder class >> endAddress [
	^ 16rE10000 - 1
]

{ #category : #writing }
BPAddPageBuilder class >> startAddress [
	^ 16rE00000
]

{ #category : #writing }
BPAddPageBuilder >> writeBankOn: aByteArray [
	self startAddress to: self endAddress do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (x + y) % 16rFF	 ]
]
