'use client'

import { useRouter } from 'next/navigation'

interface Service {
  id: number
  name: string
}

interface Facility {
  id: number
  service_id: number
  detail?: { name: string }[]
}

interface ReviewCheckTaskData {
  id: number
  status: string
}

interface ReviewCheckData {
  id?: number
  facility_id?: number
  reviewer_name?: string
  google_account_name?: string
  email?: string
  review_url?: string
  review_star?: number
  is_approved?: boolean
  is_giftcode_sent?: boolean
  feedback?: string | null
}

// 投稿確認ステータスの選択肢
const CONFIRMATION_STATUS_OPTIONS = [
  { value: 'pending', label: '確認中' },
  { value: 'confirmed', label: '成功' },
  { value: 'already_confirmed', label: '既出' },
  { value: 'failed', label: '失敗' },
] as const

type ConfirmationStatusValue = typeof CONFIRMATION_STATUS_OPTIONS[number]['value']

// tasksから投稿確認ステータスを計算
function getConfirmationStatusFromTasks(tasks?: ReviewCheckTaskData[]): ConfirmationStatusValue {
  if (!tasks || tasks.length === 0) {
    return 'pending'
  }

  const statuses = tasks.map(t => t.status)

  // どちらかがconfirmedの場合 => 成功
  if (statuses.some(s => s === 'confirmed')) {
    return 'confirmed'
  }

  // 両方がalready_confirmedの場合 => 既出
  if (statuses.length >= 2 && statuses.every(s => s === 'already_confirmed')) {
    return 'already_confirmed'
  }

  // 両方がfailedの場合 => 失敗
  if (statuses.length >= 2 && statuses.every(s => s === 'failed')) {
    return 'failed'
  }

  // 上記以外 => 確認中
  return 'pending'
}

interface ReviewCheckFormProps {
  services: Service[]
  facilities: Facility[]
  initialData?: ReviewCheckData
  defaultServiceId?: number
  tasks?: ReviewCheckTaskData[]
}

export default function ReviewCheckForm({
  services,
  facilities,
  initialData,
  defaultServiceId,
  tasks
}: ReviewCheckFormProps) {
  const router = useRouter()

  // Get service_id from facility
  const getServiceId = () => {
    if (initialData?.facility_id) {
      const facility = facilities.find(f => f.id === initialData.facility_id)
      return facility?.service_id || services[0]?.id || ''
    }
    if (defaultServiceId) {
      return defaultServiceId
    }
    return services[0]?.id || ''
  }

  const serviceId = getServiceId()
  const confirmationStatus = getConfirmationStatusFromTasks(tasks)

  // 施設名を取得
  const getFacilityName = () => {
    const facility = facilities.find(f => f.id === initialData?.facility_id)
    return facility?.detail?.[0]?.name || `施設ID: ${initialData?.facility_id}`
  }

  // 投稿確認ステータスのラベルを取得
  const getConfirmationStatusLabel = () => {
    const option = CONFIRMATION_STATUS_OPTIONS.find(o => o.value === confirmationStatus)
    return option?.label || '-'
  }

  return (
    <div className="bg-white rounded shadow border border-gray-200 p-6 max-w-2xl">
      <div className="space-y-6">
        {/* Facility */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            施設
          </label>
          <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
            {getFacilityName()}
          </div>
        </div>

        {/* Reviewer Info */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              投稿者名
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
              {initialData?.reviewer_name || '-'}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Googleアカウント名
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
              {initialData?.google_account_name || '-'}
            </div>
          </div>
        </div>

        {/* Contact Info */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            メールアドレス
          </label>
          <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
            {initialData?.email || '-'}
          </div>
        </div>

        {/* Review Info */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="md:col-span-2">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              レビューURL
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700 break-all">
              {initialData?.review_url ? (
                <a href={initialData.review_url} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                  {initialData.review_url}
                </a>
              ) : '-'}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              評価（星）
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
              {initialData?.review_star || '-'}
            </div>
          </div>
        </div>

        {/* Feedback */}
        {initialData?.feedback && (
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              ご意見・ご感想
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700 whitespace-pre-wrap">
              {initialData.feedback}
            </div>
          </div>
        )}

        {/* Confirmation Status */}
        {initialData?.id && (
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              投稿確認
            </label>
            <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
              {getConfirmationStatusLabel()}
            </div>
          </div>
        )}

        {/* Status */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            ステータス
          </label>
          <div className="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg text-sm text-gray-700">
            <div className="flex flex-wrap gap-2">
              {initialData?.is_approved && (
                <span className="inline-flex px-2 py-1 text-xs font-medium rounded bg-green-100 text-green-800">
                  承認済み
                </span>
              )}
              {initialData?.is_giftcode_sent && (
                <span className="inline-flex px-2 py-1 text-xs font-medium rounded bg-blue-100 text-blue-800">
                  ギフトコード送付済み
                </span>
              )}
              {!initialData?.is_approved && !initialData?.is_giftcode_sent && '-'}
            </div>
          </div>
        </div>

        {/* Back Button */}
        <div className="flex gap-3 pt-4">
          <button
            type="button"
            onClick={() => router.push(`/management/reviews?service=${serviceId}`)}
            className="px-6 py-2 bg-white border border-gray-300 text-gray-700 rounded text-sm hover:bg-gray-50 transition-colors font-medium"
          >
            戻る
          </button>
        </div>
      </div>
    </div>
  )
}
