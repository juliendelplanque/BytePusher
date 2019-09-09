Class {
	#name : #BPAddCarryFlagPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> endAddress [
	^ 16rE20000 - 1
]

{ #category : #accessing }
BPAddCarryFlagPageBuilder class >> startAddress [
	^ 16rE10000
]

{ #category : #writing }
BPAddCarryFlagPageBuilder >> writeBankOn: aByteArray [
	self startAddress to: self endAddress do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: ((x + y) // 16rFF > 0) asBit	 ]
]
